#!/usr/bin/ruby
# encoding: utf-8
require 'nokogiri'
require 'rake'
require 'open3'

class IndentError < StandardError; end
class PygmentsError < StandardError; end

# A module to be extended onto a String instance
# Overall, this project is for "Mastering Algorithms with C" (Mac).
# It swaps code nodes using Nokogiri (Nok) after piping them through
# indent (in) and pygmentize (py).
module MacNokinpy
    def format_code
        reduce_block_comments
            .replace_html_entities
            .indent
            .pygmentize
    end

    # Reduce annoying block comments
    def reduce_block_comments
        gsub(/^\s*\*\s+\*\s*$/, '')       # Get rid of otherwise-empty double asterisk lines
            .gsub(/^\s*\/\*+$/, '')         # Get rid of *long* opening block comment lines
            .gsub(/^\s*\*+\/\s*$/, '')      # Get rid of *long* closing block comment lines
            .gsub(/\n\n/, ?\n)              # Get rid of double newlines
            .gsub(/^(\s*)(\*\s+.*)\s+(\*)\s*$/, '\1/\2\3/')  # Make block comment lines open and close their own comments
            .extend MacNokinpy
    end

    # Replace html entities (they'll come right back when piped through pygmentize)
    def replace_html_entities
        gsub(/&amp;/,  ?&)
            .gsub(/&gt;/,   ?>)
            .gsub(/&lt;/,   ?<)
            .gsub(/&quot;/, ?")
            .gsub(/&#39;/,  ?')
            .extend MacNokinpy
    end

    def indent indent_options=%W{+blank-lines-after-declarations +blank-lines-before-block-comments +braces-after-func-def-line +brace-indent0 +braces-on-if-line +blank-before-sizeof +indent-level4 +no-tabs}
        out_and_back "indent +standard-output #{indent_options.join ?\s}",
            IndentError, "Problem in system call to 'indent': ", " See 'man indent'\n"
    end

    def pygmentize
        out_and_back "pygmentize -l c -f html",
            PygmentsError, "Problem in system call to 'pygmentize': ", " See 'pygmentize --help'\n"
    end

    # Pipe self out to command and return result from stdout
    # On error, raise error_class and sandwich stderr message
    # between error_string1 and error_string2
    def out_and_back command, error_class = StandardError, error_string1 = "", error_string2 = ""
        result = ''.extend MacNokinpy
        Open3.popen3 command do | stdin, stdout, stderr |
            stdin.puts self
            stdin.close
            while temp = stdout.gets
                result << temp
            end
            while temp = stderr.gets
                raise error_class.new "#{error_string1}#{temp}\n#{error_string2}\n"
            end
        end
        result
    end
end

# Re-write all the Html files in OEBPS
FileList['OEBPS/*.html'].each do |filename|
    print "Currently working on #{filename}..."
    doc = Nokogiri::HTML.parse( IO.read filename )
    (doc / 'pre.programlisting').each do |node|
        new_code = (Nokogiri::HTML.parse(node.content.extend(MacNokinpy).format_code) / 'div.highlight').first
        node.swap new_code
    end

    IO.write filename, doc.to_s
    puts "Done"
end

# Append pygmentize styles to Css file
# (Run pygmentize -L styles for list of available styles)
style = 'monokai'
background_color = '#333'
filename = 'OEBPS/core.css'
print "Currently working on #{filename}..."
File.open filename, 'a+' do |file|
    css = "".extend(MacNokinpy)
        .out_and_back("pygmentize -S #{style} -f html", PygmentsError)
    file.puts "/* Pygments content follows... */"
    file.puts "div.highlight { background-color: #{background_color}; }"
    file.puts css
end
puts "Done"


task :backup do
    cp "Mastering Algorithms with C - Kyle Loudon.epub",
        "Mastering Algorithms with C - Kyle Loudon.orig.epub"
end

task :to_zip => :backup do
    mv "Mastering Algorithms with C - Kyle Loudon.epub",
        "Mastering Algorithms with C - Kyle Loudon.zip"
end

task :unzip => :to_zip do
    system "unzip 'Mastering Algorithms with C - Kyle Loudon.zip'"
end

task :fix => :unzip do
    # Array of 2-tuples where first element is filename, and second element
    # is array of 2-tuples specifying line fixes
    fixes = [
        ['OEBPS/ch17s03.html', [65, "   &amp;&amp; MAX(p3.y, p4.y) &gt;= MIN(p1.y, p2.y))) {\n"]]
    ]

    fixes.each do |(file, corrections)|
        print "Fixing #{file}..."
        text = IO.readlines file
        corrections.each { |(line_No, line)| text[line_No] = line }
        IO.write file, text.join('')
        puts "Done"
    end
end

task :reformat => :fix do
    system "ruby macnokinpy.rb"
end

task :zip => :reformat do
    system "rm 'Mastering Algorithms with C - Kyle Loudon.zip'"
    system "zip 'Mastering Algorithms with C - Kyle Loudon' mimetype OEBPS/* META-INF/*"
end

task :to_epub => :zip do
    mv "Mastering Algorithms with C - Kyle Loudon.zip",
        "Mastering Algorithms with C - Kyle Loudon.epub"
end

task :default => [:to_epub, :clean]

task :clean do
    system "rm mimetype"
    system "rm -R OEBPS META-INF"
end

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
    fixes = [
       {:file => 'OEBPS/ch17s03.html',
        :lines => [
            [65, "   &amp;&amp; MAX(p3.y, p4.y) &gt;= MIN(p1.y, p2.y))) {\n"]
        ]}
    ]

    fixes.each do |fix|
        print "Fixing #{fix[:file]}..."
        text = IO.readlines fix[:file]
        fix[:lines].each do |(line_No, line)|
            text[line_No] = line
        end
        IO.write fix[:file], text.join('')
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

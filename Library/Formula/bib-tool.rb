# This is needed because of a problem with the tarball for 2.60
# Hopefully, it will not be needed for future releases
# See https://github.com/Homebrew/homebrew/issues/40559
class BibToolDownloadStrategy < CurlDownloadStrategy
  def stage
     with_system_path { safe_system 'tar', 'xqf', cached_location, 'BibTool/doc/bibtool.tex' }
     with_system_path { safe_system 'tar', 'xf', cached_location, '--exclude', 'BibTool/doc/bibtool.tex' }
     chdir
  end
end

class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html"
  url "http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-2.60.tar.gz",
    :using => BibToolDownloadStrategy
  sha256 "db84b264df7c069b5b1c8e0778dc70f4e335cd1c39d711dcd65bae02df809ad1"

  bottle do
    sha1 "d5822fd899e1238c75964b7c0763dad2f24386e7" => :yosemite
    sha1 "dcaaf50c9992f1e1812845914ab3bd4b8be521de" => :mavericks
    sha1 "e0b9efe0a08a1c02a94ddd95fdfcef8863f1ad01" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-kpathsea"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS
    system "#{bin}/bibtool", "test.bib"
  end
end

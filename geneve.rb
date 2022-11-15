class Geneve < Formula
  desc "Generate data from languages and models"
  homepage "https://github.com/elastic/geneve"
  url "https://github.com/elastic/geneve/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e7b99b1fea9ca5e19a59420338e03cdbcee3d2aa711e17050f077ea3697066df"

  depends_on "go"
  depends_on "python@3.10"

  def install
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/elastic/geneve").install buildpath.children
    cd "src/github.com/elastic/geneve" do
      system "go", "build", "-o", bin/"geneve", "."
    end
  end

  test do
    system "geneve", "version"
  end
end

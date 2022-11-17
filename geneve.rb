class Geneve < Formula
  include Language::Python::Virtualenv

  desc "Generate data from languages and models"
  homepage "https://github.com/elastic/geneve"
  license "Apache-2.0"

  url "https://github.com/elastic/geneve/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f6469a854cd72c40ee1f07c65c2bca3d244e520b8d5fd802f336aec51828d211"

  depends_on "go"
  depends_on "pkg-config"
  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "elastic-transport" do
    url "https://files.pythonhosted.org/packages/91/23/9d00188faa9f1d62654e6e35761e320837e5f43c893e3935535adf40226d/elastic-transport-8.4.0.tar.gz"
    sha256 "b9ad708ceb7fcdbc6b30a96f886609a109f042c0b9d9f2e44403b3133ba7ff10"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/24/45/39cb8efdfb3e31dd6bb94916758ccde89bb4c7ddbef1d948361c78f7e3e8/elasticsearch-8.5.0.tar.gz"
    sha256 "47cfc484ebca07371a9dbd9ce333c55f450daf0790a799944a91234df3d34c5a"
  end

  resource "eql" do
    url "https://files.pythonhosted.org/packages/11/00/92a465c8e8df92fa769387e8962921b847fe5b880a2caf38f56e3dd9b2a1/eql-0.9.15.tar.gz"
    sha256 "f1754e38a2555c40fde3ec9fb8a5b9b4ba81c9aaeb21116788e84e42d1e29592"
  end

  resource "geneve" do
    url "https://files.pythonhosted.org/packages/bc/58/bf35f0976b5b3af98e87d50fd72ccca5fd2af2d9c437a7bae5d6bbe13c7c/geneve-0.1.1.tar.gz"
    sha256 "0ae9777492204cacc24b38a23a164fceb89b7581d7640e9b5e1fbad4a147ea2e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "lark-parser" do
    url "https://files.pythonhosted.org/packages/5a/ee/fd1192d7724419ddfe15b6f17d1c8742800d4de917c0adac3b6aaf22e921/lark-parser-0.12.0.tar.gz"
    sha256 "15967db1f1214013dca65b1180745047b9be457d73da224fcda3d9dd4e96a138"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/f4/ba/98ee2054a2d7b8bebd367d442e089489250b6dc2aee558b000e961467212/pytoml-0.1.21.tar.gz"
    sha256 "8eecf7c8d0adcff3b375b09fe403407aa9b645c499e5ab8cac670ac4a35f61e7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resources

    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/geneve").install buildpath.children
    cd "src/github.com/elastic/geneve" do
      system "go", "build", "-o", libexec/"bin/geneve", "."
    end

    (bin/"geneve").write <<~EOF
      #!/bin/sh

      # execute in the cellar venv
      exec #{libexec}/bin/geneve "$@"
    EOF

    chmod 0755, bin/"geneve"
  end

  test do
    system "geneve", "version"
  end
end

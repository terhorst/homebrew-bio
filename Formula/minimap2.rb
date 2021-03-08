class Minimap2 < Formula
  # cite Li_2018: "https://doi.org/10.1093/bioinformatics/bty191"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17.tar.bz2"
  sha256 "b68ac8882d33cc63e9e3246775062aeb159b6990ff7f38099172c3fe6f8a2742"
  head "https://github.com/lh3/minimap2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, sierra:       "cf78c0b192a7766dcebc18df96ef90492af999dae1903bcdbf360c150936abda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8db660e19fb613e93dbcf0ebfecd4b7741bb349906e00e0a7aa73009809e806b"
  end

  depends_on "brewsci/bio/k8" # for paftools.js

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "minimap2"
    bin.install "misc/paftools.js"
    bin.install_symlink "paftools.js" => "paftools"
    man1.install "minimap2.1"
    pkgshare.install "python", "test", "misc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minimap2 --version 2>&1")
    assert_match(/\d/, shell_output("#{bin}/paftools version 2>&1"))
  end
end

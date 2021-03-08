class Phyx < Formula
  # cite Brown_2017: "https://doi.org/10.1093/bioinformatics/btx063"
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v1.01.tar.gz"
  sha256 "edc1d6f20cc606b086f54c74631ec434ed49d76c2f3feea5302cd02da27e054a"
  license "GPL-3.0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, mojave:       "561513bd343850933d8f034617bb6990100bb8ffbd5f3a6fc7c8145c43401f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0b324a7fa20c5f57d4de10ae5034c2885ad7006c04c24107bef67a33a3c1131f"
  end

  depends_on "armadillo"
  depends_on "nlopt"

  def install
    cd "src" do
      if OS.linux?
        inreplace "Makefile.in" do |s|
          # When bottling, disable opportunistic linking to libmvec,
          # which causes runtime errors on glibc > 2.19 and < 2.22
          s.gsub! "-ftree-vectorize", "-fno-tree-vectorize" if ENV["CIRCLECI"]
        end
      end
      system "./configure", "--prefix=#{prefix}"
      system "make"
      bin.mkdir
      system "make", "install"
    end
    pkgshare.install Dir["example_files/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pxseqgen --help")
    system "#{bin}/pxseqgen", "-t", "#{pkgshare}/pxseqgen_example/seqgen_test.tre", "-o", "output.fa"
    assert_predicate testpath/"output.fa", :exist?
  end
end

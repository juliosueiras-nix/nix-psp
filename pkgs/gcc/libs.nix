{ fetchTarball, ... }:

let
  GMP_VERSION = "6.1.2";
  MPC_VERSION = "1.1.0";
  MPFR_VERSION = "4.0.2";
  ISL_VERSION = "0.21";
in {
  gmpLib = fetchTarball {
    url = "https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VERSION}.tar.bz2";
    sha256 = "15xl9qaacbq9i5822g8nvr4xx859pypvxjngcig5344pyi14rck5";
  };

  mpcLib = fetchTarball {
    url = "https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz";
    sha256 = "1945hsrqva71z0jv00hhbp1j90n7gf3hcf8bynnrgdb3yqk138lj";
  };

  mpfrLib = fetchTarball {
    url = "https://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VERSION}.tar.bz2";
    sha256 = "0jbw7awqlhs80svz2m5619sg1dw0kb8fiw3a3x228dzcxxmdk94g";
  };

  islLib = fetchTarball {
    url = "http://isl.gforge.inria.fr/isl-${ISL_VERSION}.tar.gz";
    sha256 = "062jxq3wk4dajs15sn0na3fjjw7bq88ir4frnfiildkw4a2zscr6";
  };
}

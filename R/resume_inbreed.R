#' @title Calculate inbreeding coefficients from scratch or resume for new individuals in the pedigree
#'
#' @param ped : A data frame with integer columns corresponding to ID, SIRE, and DAM. IDs should be sequential, starting from 1. Missing parents (SIRE and DAM) are denoted as 0.
#' @param f : (Optional) If available, the vector of inbreeding coefficients from the previous calculation of inbreeding coefficients with less number of animals in the pedigree.
#' @param d : (Optional) If available, the vector of the diagonal elements of the diagonal matrix \bold{D} in \eqn{\mathbf A = \mathbf{TDT}'}
#' from the previous calculation of inbreeding coefficients with less number of animals in the pedigree,
#' where \bold{A} is the numerator relationship matrix.
#' @param export_d : `FALSE` (default) or `TRUE`. If `TRUE`, vector `d` is retuned for future use.
#'
#' @return : Vector of inbreeding coefficients if `export_d == FALSE`,
#' or a list containing the vector of inbreeding coefficients and the vector of `d` coefficients if `export_d == TRUE`.
#' @export
#'
#' @examples
#' # A sample pedigree data frame:
#' ped <- data.frame(
#'     ID = 1:12,
#'     SIRE = c(0, 0, 0, 2, 2, 0, 4, 6, 0, 6, 10, 10),
#'     DAM = c(0, 0, 0, 1, 1, 0, 3, 5, 7, 8, 9, 0)
#' )
#'
#' oldped <- ped[1:9, ]
#' (oldrun <- resume_inbreed(oldped, export_d = TRUE))
#' resume_inbreed(ped)
#' resume_inbreed(ped, f = oldrun$f)
#' resume_inbreed(ped, f = oldrun$f, d = oldrun$d)
#'
resume_inbreed <- function(ped, f = c(), d = c(), export_d = FALSE) {
    message("Estimating inbreeding coefficients based on Meuwissen and Luo (1992)")
    # length(f) == 0 means start from scratch
    stopifnot(length(f) < nrow(ped))
    stopifnot(length(d) == length(f) | length(d) == 0)
    stopifnot(identical(ped[, 1], 1:nrow(ped)))
    N <- nrow(ped)
    M <- length(f)
    O <- length(d)
    L <- POINT <- rep(0, N)
    f <- c(f, rep(0, N - M))
    d <- c(d, rep(1, N - O))
    ped$P1 <- apply(ped[, 2:3], 1, FUN = max)
    ped$P2 <- apply(ped[, 2:3], 1, FUN = min)
    if (M > 0 & O == 0) {
        # Calculate d[1:M]
        for (I in 1:M)
        {
            P1 <- ped$P1[I]
            P2 <- ped$P2[I]
            if (P2 == 0) {
                if (P1 > 0) d[I] <- (3 - f[P1]) / 4
            } else if (P1 == ped$P1[I - 1] & P2 == ped$P2[I - 1]) {
                d[I] <- d[I - 1]
            } else {
                d[I] <- (2 - f[P1] - f[P2]) / 4
            }
        }
    }
    for (I in (M + 1):N)
    {
        P1 <- ped$P1[I]
        P2 <- ped$P2[I]
        if (P2 == 0) {
            if (P1 > 0) d[I] <- (3 - f[P1]) / 4
        } else if (P1 == ped$P1[I - 1] & P2 == ped$P2[I - 1]) {
            d[I] <- d[I - 1]
            f[I] <- f[I - 1]
        } else {
            d[I] <- (2 - f[P1] - f[P2]) / 4
            fI <- -1
            L[I] <- 1
            J <- I
            while (J != 0) {
                K <- J
                R <- L[K] / 2
                KS <- ped$P1[K]
                KD <- ped$P2[K]
                if (KS > 0) {
                    while (POINT[K] > KS) K <- POINT[K]
                    L[KS] <- L[KS] + R
                    if (KS != POINT[K]) {
                        POINT[KS] <- POINT[K]
                        POINT[K] <- KS
                    }
                    if (KD > 0) {
                        while (POINT[K] > KD) K <- POINT[K]
                        L[KD] <- L[KD] + R
                        if (KD != POINT[K]) {
                            POINT[KD] <- POINT[K]
                            POINT[K] <- KD
                        }
                    }
                }
                fI <- fI + L[J]^2 * d[J]
                L[J] <- 0
                K <- J
                J <- POINT[J]
                POINT[K] <- 0
            }
            f[I] <- fI
        }
    }
    if (export_d) {
        return(list("f" = f, "d" = d))
    } else {
        return(f)
    }
}

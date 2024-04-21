#' @title Compute numerator relationship coefficients between two distinct groups of individuals
#'
#' @param ped : A data frame with integer columns corresponding to ID, SIRE, and DAM. IDs should be sequential, starting from 1. Missing parents (SIRE and DAM) are denoted as 0.
#' @param set1 : A set of individual IDs.
#' @param set2 : A set of individual IDs, distinct from `set1`.
#' @param type : \code{"notdam-notsire"} (default), \code{"sire-sire"}, or \code{"dam-dam"} relationships
#' \describe{
#'  \item{\code{"notdam-notsire"}}{requires `set1` and `set2` individuals not to be members of `ped$DAM` and `ped$SIRE`, respectively.}
#'  \item{\code{"sire-sire"}}{requires `set1` and `set2` individuals to be members of `ped$SIRE`.}
#'  \item{\code{"dam-dam"}}{requires `set1` and `set2` individuals to be members of `ped$DAM`.}
#' }
#'
#' @return : Numerator relationship coefficients between `set1` and `set2` individuals in the form of a matrix (a partition of the numerator relationship matrix \bold{A}).
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
#' # Example 1: Calculate inbreeding coefficients.
#' ggroups::inbreed(ped)
#'
#' # Example 2: Calculate relationship coefficients between two groups of animals,
#' # one's members not among dams, and the members of the other not among sires.
#' calcR(ped, set1 = c(12, 6), set2 = c(11, 8), type = "notdam-notsire")
#' # Since `"notdam-notsire"` is the default type, `type = "notdam-notsire"` might be omitted.
#'
#' # Example 3: Calculate relationship coefficients between dam 7 and dams 8 and 9.
#' calcR(ped, set1 = 7, set2 = 8:9, type = "dam-dam")
#'
#' # Example 4: Calculate relationship coefficients between sires 2 & 6 and sires 4 & 10.
#' calcR(ped, set1 = c(2, 6), set2 = c(4, 10), type = "sire-sire")
#'
calcR <- function(ped, set1, set2, type = "notdam-notsire") {
    # Check type
    if (length(type) != 1) stop("type most be of length 1.")
    if (!type %in% c("notdam-notsire", "sire-sire", "dam-dam")) stop("type most be 'notdam-notsire', 'sire-sire', or 'dam-dam'.")
    # Check ped
    if (any(!c("ID", "SIRE", "DAM") %in% colnames(ped))) stop("The pedigree data frame should contain ID, SIRE, and DAM columns.")
    ped <- ped[, c("ID", "SIRE", "DAM")]
    if (any(is.na(ped))) stop("Found NA in the pedigree.")
    if (any(ped$ID == 0)) stop("Found 0 in ped$ID.")
    if (nrow(ped[duplicated(ped$ID), ]) > 0) stop("Found duplicates in ped$ID.")
    sires <- unique(ped[ped$SIRE != 0, ]$SIRE)
    dams <- unique(ped[ped$DAM != 0, ]$DAM)
    if (any(sires %in% dams)) stop("Found an overlap between sires and dams.")
    # Check set1
    if (any(is.na(set1))) stop("Found NA in set1.")
    if (any(set1 == 0)) stop("Found 0 in set1.")
    if (length(set1[duplicated(set1)]) > 0) stop("Found duplicates in set1.")
    # Check set2
    if (any(is.na(set2))) stop("Found NA in set2.")
    if (any(set2 == 0)) stop("Found 0 in set2.")
    if (length(set2[duplicated(set2)]) > 0) stop("Found duplicates in set2.")
    if (any(set1 %in% set2)) stop("Found an overlap between set1 and set2.")
    # Additional checks for set1 and set2
    if (type == "notdam-notsire") {
        if (any(set1 %in% dams)) stop("Found dam(s) in set1.")
        if (any(set2 %in% sires)) stop("Found sire(s) in set2.")
        if (any(!set1 %in% ped$ID)) stop("Found element(s) of set1 not in ped$ID.")
        if (any(!set2 %in% ped$ID)) stop("Found element(s) of set2 not in ped$ID.")
    } else if (type == "sire-sire") {
        if (any(!set1 %in% sires)) stop("Found element(s) of set1 not in sires.")
        if (any(!set2 %in% sires)) stop("Found element(s) of set2 not in sires.")
    } else {
        if (any(!set1 %in% dams)) stop("Found element(s) of set1 not in dams.")
        if (any(!set2 %in% dams)) stop("Found element(s) of set2 not in dams.")
    }
    # Append dummy progeny
    ## type == "notdam-notsire": There is an additional cost of computing inbreeding coefficient for a dummy progeny of the parents who already have a real progeny.
    ## However, it reduces data handling cost as if we were to pick the realy progeny or pick a real progeny from a few progenies.
    tmp <- data.frame(
        ID = nrow(ped) + (1:(length(set1) * length(set2))),
        SIRE = rep(set1, each = length(set2)),
        DAM = rep(set2, length(set1))
    )
    ped <- rbind(ped, tmp)
    # Calculate inbreeding coefficients
    F_coef <- ggroups::inbreed(ped)
    names(F_coef) <- ped$ID
    # Calculate the relationship matrix
    R <- matrix(0, nrow = length(set1), ncol = length(set2), dimnames = list(set1, set2))
    tmp$F <- F_coef[(length(F_coef) - nrow(tmp) + 1):length(F_coef)]
    tmp$rnum <- match(tmp$SIRE, rownames(R))
    tmp$cnum <- match(tmp$DAM, colnames(R))
    R[as.matrix(tmp[, c("rnum", "cnum")])] <- tmp$F * 2
    return(R)
}
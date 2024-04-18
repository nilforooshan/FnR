#' @title Compute numerator relationship coefficients between two groups of dams
#'
#' @param ped : A data frame with integer columns corresponding to ID, SIRE, and DAM. IDs should be sequential, starting from 1. Missing parents (SIRE and DAM) are denoted as 0.
#' @param set1 : A set of dam IDs.
#' @param set2 : A set of dam IDs, distinct from `set1`.
#'
#' @return : Numerator relationship coefficients between `set1` and `set2` individuals in the form of a matrix.
#' @export
#'
#' @examples
#' message("TODO: Write example(s).")
#'
dam_dam <- function(ped, set1, set2) {
    # Check ped
    if (any(!c("ID", "SIRE", "DAM") %in% colnames(ped))) stop("The pedigree data frame should contain ID, SIRE, and DAM columns.")
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
    if (any(!set1 %in% dams)) stop("Found element(s) of set1 not in dams.")
    # Check set2
    if (any(is.na(set2))) stop("Found NA in set2.")
    if (any(set2 == 0)) stop("Found 0 in set2.")
    if (length(set2[duplicated(set2)]) > 0) stop("Found duplicates in set2.")
    if (any(!set2 %in% dams)) stop("Found element(s) of set2 not in dams.")
    if (any(set1 %in% set2)) stop("Found an overlap between set1 and set2.")
    # TODO: Continue writting the script.
    ped <- ped[, c("ID", "SIRE", "DAM")]
    output <- matrix(1)
    return(output)
}

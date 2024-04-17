#' @title Compute numerator relationship coefficients between two groups of sires
#'
#' @param ped : A data frame with the first columns being ID, SIRE, and DAM.
#' Missing parents (SIRE and DAM) are denoted as 0.
#' @param set1 : A set of sire IDs.
#' @param set2 : A set of sire IDs, distict from `set1`.
#'
#' @return : Numerator relationship coefficients between `set1` and `set2` individuals.
#' @export
#'
#' @examples
#' message("TODO:")
#'
sire_sire <- function(ped, set1, set2) {
    # Check ped
    ped <- ped[, 1:3]
    if (!identical(colnames(ped), c("ID", "SIRE", "DAM"))) stop("The first three colnames of ped should be ID, SIRE, and DAM.")
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
    if (any(!set1 %in% sires)) stop("Found element(s) of set1 not in sires.")
    # Check set2
    if (any(is.na(set2))) stop("Found NA in set2.")
    if (any(set2 == 0)) stop("Found 0 in set2.")
    if (length(set2[duplicated(set2)]) > 0) stop("Found duplicates in set2.")
    if (any(!set2 %in% sires)) stop("Found element(s) of set2 not in sires.")
    if (any(set1 %in% set2)) stop("Found an overlap between set1 and set2.")
    # TODO: Begin the process.
    output <- matrix(1) # DELETE
    return(output)
}

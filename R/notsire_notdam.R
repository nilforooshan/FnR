#' @title Compute numerator relationship coefficients between non-sires and non-dams
#'
#' @param ped : A data frame with integer columns corresponding to ID, SIRE, and DAM. IDs should be sequential, starting from 1. Missing parents (SIRE and DAM) are denoted as 0.
#' @param notsire : A set of individual IDs that cannot be found among `ped$SIRE`.
#' @param notdam : A set of individual IDs (distinct from `notsire`) that cannot be found among `ped$DAM`.
#'
#' @return : Numerator relationship coefficients between `notsire` and `notdam` individuals in the form of a matrix.
#' @export
#'
#' @examples
#' message("TODO: Write example(s).")
#'
notsire_notdam <- function(ped, notsire, notdam) {
    # Check ped
    if (any(!c("ID", "SIRE", "DAM") %in% colnames(ped))) stop("The pedigree data frame should contain ID, SIRE, and DAM columns.")
    if (any(is.na(ped))) stop("Found NA in the pedigree.")
    if (any(ped$ID == 0)) stop("Found 0 in ped$ID.")
    if (nrow(ped[duplicated(ped$ID), ]) > 0) stop("Found duplicates in ped$ID.")
    sires <- unique(ped[ped$SIRE != 0, ]$SIRE)
    dams <- unique(ped[ped$DAM != 0, ]$DAM)
    if (any(sires %in% dams)) stop("Found an overlap between sires and dams.")
    # Check notsire
    if (any(is.na(notsire))) stop("Found NA in notsire.")
    if (any(notsire == 0)) stop("Found 0 in notsire.")
    if (length(notsire[duplicated(notsire)]) > 0) stop("Found duplicates in notsire.")
    if (any(notsire %in% sires)) stop("Found sire(s) in notsire.")
    if (any(!notsire %in% ped$ID)) stop("Found element(s) of notsire not in ped$ID.")
    # Check notdam
    if (any(is.na(notdam))) stop("Found NA in notdam.")
    if (any(notdam == 0)) stop("Found 0 in notdam.")
    if (length(notdam[duplicated(notdam)]) > 0) stop("Found duplicates in notdam.")
    if (any(notdam %in% dams)) stop("Found dam(s) in notdam.")
    if (any(!notdam %in% ped$ID)) stop("Found element(s) of notdam not in ped$ID.")
    if (any(notsire %in% notdam)) stop("Found an overlap between notsire and notdam.")
    # TODO: Continue writting the script.
    ped <- ped[, c("ID", "SIRE", "DAM")]
    output <- matrix(1)
    return(output)
}

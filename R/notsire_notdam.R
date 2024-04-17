#' @title Compute numerator relationship coefficients between non-sires and non-dams
#'
#' @param ped : A data frame with the first columns being ID, SIRE, and DAM.
#' Missing parents (SIRE and DAM) are denoted as 0.
#' @param notsire : A set of individual IDs that cannot be found among `ped$SIRE`.
#' @param notdam : A set of individual IDs (distict from `notsire`) that cannot be found among `ped$DAM`.
#'
#' @return : Numerator relationship coefficients between `notsire` and `notdam` individuals.
#' @export
#'
#' @examples
#' message("TODO:")
#'
notsire_notdam <- function(ped, notsire, notdam) {
    # Check ped
    ped <- ped[, 1:3]
    if (!identical(colnames(ped), c("ID", "SIRE", "DAM"))) stop("The first three colnames of ped should be ID, SIRE, and DAM.")
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
    # TODO: Begin the process.
    output <- matrix(1) # DELETE
    return(output)
}

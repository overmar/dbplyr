context("Equivalence (grouped)")

srcs <- lahman_srcs("df", "postgres", "sqlite")
players <- lapply(srcs, function(src) {
  src %>% tbl("Batting") %>% group_by(playerID)
})

test_that("n the same regardless of tbl", {
  # Can't test group_size directly, because no assurance that groups are in the
  # same order

  compare_tbls(players, function(tbl) tbl %>% summarise(n = n()),
    compare = equal_data_frame, convert = TRUE)
})

test_that("mutate the same regardless of tbl", {
  ok <- intersect(names(players), c("df", "postgres"))

  compare_tbls(players[ok], function(tbl) {
    tbl %>% select(playerID, yearID) %>%
      mutate(cyear = yearID - min(yearID) + 1)
  })
})

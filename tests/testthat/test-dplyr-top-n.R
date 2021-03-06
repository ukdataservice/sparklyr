context("dplyr top_n")
sc <- testthat_spark_connection()

test_that("top_n works as expected", {
  test_requires("dplyr")

  test_data <- c()
  for (i in 1:length(LETTERS))
  {
    test_data <- c(test_data, rep.int(LETTERS[i], times = i * 10))
  }

  test_data <- data.frame("X" = test_data)
  test_tbl <- copy_to(sc, test_data)

  tn1 <- test_tbl %>% count(X) %>% top_n(10) %>% collect()
  tn2 <- test_data %>% count(X) %>% top_n(10)

  tn2 <- tn2 %>% arrange(X)
  tn1 <- tn1 %>% arrange(X)

  testthat::expect_true(all(tn1 == tn2))
})

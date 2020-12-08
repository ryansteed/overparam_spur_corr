library(tidyverse)

df = tibble() %>% add_column(
  p = NA, scr = NA, 
  worst_group_test_error = NA, 
  # "group_0" = NA, "group_1" = NA, "group_2" = NA, "group_3" = NA)
  mean_test_error = NA,
  worst_group_train_error = NA, 
  mean_train_error = NA
)
for (p_maj in c(0.5, 0.6, 0.7, 0.8, 0.9)) {
  for (scr in c(0.1, 0.4, 0.7, 1.0, 1.3, 1.6)) {
    print(paste0("results/p=", p_maj, "_scr=",  scr, ".csv"))
    results = read.csv(paste0("results/p=", p_maj, "_scr=",  format(scr, nsmall=1), ".csv"))
    test_errors = results %>%
      select(starts_with("test")) %>%
      summarise(across(everything(), mean)) %>% 
      slice(1) %>%
      unlist(., use.names=FALSE)
    w_test = max(test_errors)
    m_test = mean(test_errors)
    train_errors = results %>%
      select(starts_with("train")) %>%
      summarise(across(everything(), mean)) %>% 
      slice(1) %>%
      unlist(., use.names=FALSE)
    w_train = max(train_errors)
    m_train = mean(train_errors)
    df = df %>% add_row(tibble_row(
      p = p_maj, 
      scr = scr, 
      worst_group_test_error = w_test,
      # "group_0" = test_errors[1],
      # "group_1" = test_errors[2],
      # "group_2" = test_errors[3],
      # "group_3" = test_errors[4],
      mean_test_error = m_test,
      worst_group_train_error = w_train,
      mean_train_error = m_train
    ))
  }
}

ggplot(df, aes(p, scr, fill=worst_group_test_error)) +
  geom_tile() +
  xlab("Size of the majority group") +
  ylab("Spurious Correlation Ratio: var(core) / var(spurious)") +
  ggtitle("Worst Group Test Error") +
  guides(fill=guide_colorbar(title="Test Error")) +
  scale_fill_viridis_c(option="B", direction = -1, limits=c(0.2, 0.4))
ggsave("figures/worst_test.png", width=6, height=4)

ggplot(df, aes(p, scr, fill=mean_test_error)) +
  geom_tile() +
  xlab("Size of the majority group") +
  ylab("Spurious Correlation Ratio: var(core) / var(spurious)") +
  ggtitle("Mean Test Error") +
  guides(fill=guide_colorbar(title="Test Error")) +
  scale_fill_viridis_c(option="B", direction = -1, limits=c(0.2, 0.4))
ggsave("figures/mean_test.png", width=6, height=4)

ggplot(df, aes(p, scr, fill=worst_group_train_error)) +
  geom_tile() +
  xlab("Size of the majority group") +
  ylab("Spurious Correlation Ratio: var(core) / var(spurious)") +
  ggtitle("Worst Group Test Error") +
  guides(fill=guide_colorbar(title="Train Error")) +
  scale_fill_viridis_c(option="D", direction = -1, limits=c(0.1, 0.2))
ggsave("figures/worst_train.png", width=6, height=4)

ggplot(df, aes(p, scr, fill=mean_train_error)) +
  geom_tile() +
  xlab("Size of the majority group") +
  ylab("Spurious Correlation Ratio: var(core) / var(spurious)") +
  ggtitle("Mean Test Error") +
  guides(fill=guide_colorbar(title="Train Error")) +
  scale_fill_viridis_c(option="D", direction = -1, limits=c(0.1, 0.2))
ggsave("figures/mean_train.png", width=6, height=4)

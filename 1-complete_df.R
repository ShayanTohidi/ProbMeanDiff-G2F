
library(dplyr)
library(tidyr)

#### Data Pre-Processing ####

year = 2020
file = paste('g2f_',year,'.csv', sep = '')

org = read.csv(file)

df_all = org %>%
  select(Pedigree, Year, Field.Location, Grain.Yield..bu.A.) %>%
  rename(loc=Field.Location, gen=Pedigree, yield=Grain.Yield..bu.A.) %>%
  unite(loc, Year, col = 'env', sep = '_') %>%
  drop_na(yield)

df_ia = df_all %>%
  filter(grepl('^IA', env))


length(unique(df_ia$gen))
length(unique(df_ia$env))

length(unique(df_all$gen))
length(unique(df_all$env))

##### one year - without imputation #####

rep_num = 2

gen_envs1 = df_ia %>%
  group_by(gen,env) %>%
  summarise(count = n()) %>%
  filter(count >= rep_num) %>%
  ungroup() %>%
  select(!count) %>%
  group_by(gen) %>%
  nest(envs = env)

envs_freq1 = gen_envs1%>%
  group_by(envs) %>%
  summarise(freq = n())

for (i in 1:nrow(envs_freq1)) {
  envs_freq1[i, 'pair_num'] = nrow(envs_freq1$envs[[i]]) * envs_freq1[i, 'freq']
}
envs_freq1 = envs_freq1%>%arrange(desc(freq))

option1 = 1
envs_subset1 = envs_freq1$envs[[option1]]$env
gens_subset1 = c()
for (i in 1:nrow(gen_envs1)) {
  if (all(gen_envs1$envs[[i]]$env == envs_subset1)) {
    gens_subset1 = append(gens_subset1, gen_envs1$gen[i])
  }
}

x = df_all %>%
  filter(gen %in% gens_subset1) %>%
  filter(env %in% envs_subset1) %>%
  group_by(gen, env) %>%
  slice_sample(n=2) %>%
  ungroup() %>%
  arrange(gen, env)

write.csv(x, paste(year, '_IA_', option1, '.csv', sep = ''), row.names = F)

df = df_all %>%
  filter(gen %in% gens_subset1) %>%
  filter(!(env %in% envs_subset1)) %>%
  bind_rows(x)

gen_envs2 = df %>%
  group_by(gen,env) %>%
  summarise(count = n()) %>%
  filter(count >= rep_num) %>%
  ungroup() %>%
  select(!count) %>%
  group_by(gen) %>%
  nest(envs = env)

envs_freq2 = gen_envs2%>%
  group_by(envs) %>%
  summarise(freq = n())

for (i in 1:nrow(envs_freq2)) {
  envs_freq2[i, 'pair_num'] = nrow(envs_freq2$envs[[i]]) * envs_freq2[i, 'freq']
}
envs_freq2 = envs_freq2%>%arrange(desc(pair_num))

option2 = 3
envs_subset2 = envs_freq2$envs[[option2]]$env
gens_subset2 = c()
for (i in 1:nrow(gen_envs2)) {
  if (all(gen_envs2$envs[[i]]$env == envs_subset2)) {
    gens_subset2 = append(gens_subset2, gen_envs2$gen[i])
  }
}

output = df %>%
  filter(gen %in% gens_subset2) %>%
  filter(env %in% envs_subset2) %>%
  group_by(gen, env) %>%
  slice_sample(n=2) %>%
  ungroup() %>%
  arrange(gen, env)

write.csv(output, paste(year,'_', option1 , '_', option2, '.csv', sep = ''), row.names = F)


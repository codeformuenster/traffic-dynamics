# Copyright © 2017 Thorben Jensen, Thomas Kluth
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

library(DBI)
library(RSQLite)
library(sqldf)
library(dplyr)
library(ggplot2)
library(gridExtra)

# LOAD DATA
wolbecker <- 
  sqldf("SELECT 
         date, hour, count, location,
         CASE location
           WHEN 'MQ_09040_FV3_G (MQ1034)' THEN 'entering_city'
           WHEN 'MQ_09040_FV1_G (MQ1033)' THEN 'leaving_city'
           END 'direction'
         FROM kfz_data
         WHERE location LIKE '%09040%'", 
         dbname = "data/processed/kfz_data.sqlite") 

# GROUPED PLOTS
# plot aggregated days over year
wolbecker %>%
  group_by(direction, date) %>%
  summarise(count_day = sum(count)) %>%
  ggplot(data = ., aes(x = date, y = count_day)) +
  geom_line(aes(group = direction, color = direction)) +
  theme_minimal()

# plot days as line plot
wolbecker %>%
  ggplot(data = ., aes(x = hour, y = count)) +
  geom_line(aes(group = interaction(date, direction), color = direction),
            alpha = .2) +
  theme_minimal()
  
# UN-GROUPED PLOTS
# plot aggregated days over year
wolbecker %>%
  group_by(date) %>%
  summarise(count_day = sum(count)) %>%
  ggplot(data = ., aes(x = date, y = count_day)) +
  geom_line(group = 1) +
  theme_minimal()

# plot days as line plot
wolbecker %>%
  group_by(date, hour) %>%
  summarise(count_sum = sum(count)) %>%
  ggplot(data = ., aes(x = hour, y = count_sum)) +
  geom_line(aes(group = date),
            alpha = .2) +
  theme_minimal()
  
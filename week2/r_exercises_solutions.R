##########################################################
# Exercise 1: Compute Sales Tax
# Define a vector of prices for different items
prices <- c(19.99, 5.49, 3.99)
# Define the sales tax rate
sales_tax <- 0.06
# Calculate the total cost including sales tax
total_cost <- sum(prices) * (1 + sales_tax)
total_cost

##########################################################
# Exercise 2: Track Monthly Expenses
# Define a named vector for monthly expenses by category
expenses <- c(rent = 1200, groceries = 350, utilities = 150, entertainment = 200)
# Calculate the total expenses for the month
total_expenses <- sum(expenses)
total_expenses
# Calculate the percentage of total expenses for each category
percentages <- expenses / total_expenses * 100
percentages

##########################################################
# Exercise 3: Analyze Survey Results
# Create a vector of survey responses
responses <- c("Yes", "No", "Yes", "Maybe", "Yes", "No", "Maybe", "Yes")
# Count the frequency of each response using the table function
response_table <- table(responses)
response_table

response_table / length(responses)

# Calculate the proportion of "Yes" responses
proportion_yes <- response_table["Yes"] / sum(response_table)
proportion_yes


##########################################################
# Exercise 4: Calculate Average Test Scores
# Create vectors for math and English test scores
math_scores <- c(90, 85, 78, 92, 88)
english_scores <- c(84, 89, 91, 77, 85)
# Calculate the average score for each subject
(math_avg <- mean(math_scores))
(english_avg <- mean(english_scores))


##########################################################
# Exercise 5: Create a Shopping List
# Create vectors for items and their prices
items <- c("apples", "bread", "milk")
prices <- c(1.99, 2.49, 3.79)
# Combine the vectors into a data frame
(shopping_list <- data.frame(items, prices))

##########################################################
# Exercise 6: Analyze Sales Data
# Create a vector of daily sales for 10 days
daily_sales <- c(200, 150, 300, 250, 400, 100, 350, 300, 450, 500)
# Calculate the total and average sales
(total_sales <- sum(daily_sales))
(average_sales <- mean(daily_sales))

# Discounted sales
# Apply a 10% discount to all sales
discounted_sales <- daily_sales * 0.9
# Calculate the total of discounted sales
total_discounted_sales <- sum(discounted_sales)
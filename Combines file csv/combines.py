import pandas as pd
import glob
import os

# Set the directory where your CSV files are located
directory_path = 'D:\Code\Auto - Get Hash\Combines file csv'  # Change this to your directory

# Use glob to get all CSV files in the directory
csv_files = glob.glob(os.path.join(directory_path, '*.csv'))

# Create an empty list to hold DataFrames
dataframes = []

# Loop through the list of CSV files and read them into DataFrames
for file in csv_files:
    df = pd.read_csv(file)
    dataframes.append(df)

# Concatenate all DataFrames into a single DataFrame
combined_df = pd.concat(dataframes, ignore_index=True)

# Save the combined DataFrame to a new CSV file
combined_df.to_csv('combined_file.csv', index=False)

print("CSV files combined successfully!")
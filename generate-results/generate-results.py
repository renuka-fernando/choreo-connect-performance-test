import json
import csv
import getpass

username = getpass.getuser()
print("Current OS user: ", username)

# Specify which columns to include in the results_summary CSV file
columns = ['payload_size', 'user_count', 'samples', 'mean', 'throughput', 'errors', 'errorPercentage', 'p90', 'p95', 'p99']

# Specify the values for payload_size and user_count
payload_sizes = ['50B', '1024B', '10240B', '102400B']
user_counts = [10, 50, 100, 200, 500, 1000]

# Open the CSV file for writing or appending
with open('results_summary.csv', 'a', newline='') as csv_file:

    # Create a CSV writer object
    writer = csv.writer(csv_file)

    # Check if the file is empty
    is_empty = csv_file.tell() == 0

    # Loop through each combination of payload_size and user_count
    for payload_size in payload_sizes:
        for user_count in user_counts:
            # Generate the filename for the current combination of payload_size and user_count
            filename = f"/home/{username}/results/cpu-1/passthrough/1g_heap/{user_count}_users/{payload_size}/0ms_sleep/results-measurement-summary.json"

            with open(filename, 'r') as json_file:
                # Load the JSON data
                data = json.load(json_file)

                # Extract the HTTP Request data
                http_request = data['HTTP Request']

                # Extract the values for the selected columns
                row = [payload_size, user_count] + [http_request[col] for col in columns[2:]]

                # Write the header row if the file is empty
                if is_empty:
                    writer.writerow(columns)
                    is_empty = False

                # Write the data row
                writer.writerow(row)

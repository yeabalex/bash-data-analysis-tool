# Bash Data Analysis Tool

This Bash script provides a simple command-line tool for basic data analysis of CSV files. It allows users to display the number of rows and columns in the CSV file, list unique values in a specified column, display minimum and maximum values for numeric columns, display the most frequent value for categorical columns, calculate summary statistics (mean, median, standard deviation) for numeric columns, filter and extract rows and column based on user-defined conditions, sort the CSV file based on a specific column..

## Requirements

- Bash (Bourne Again SHell)
- awk
- bc

## Usage

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yeabsira-alemu/bash-data-analysis-tool.git
    ```

2. **Navigate to the directory:**

    ```bash
    cd bash-data-analysis-tool
    ```

3. **Provide your CSV file:**

    Make sure your CSV file is in the Datasets directory and is located in the same directory as the script. Alternatively, you can modify the script to accept a file path as an argument.

4. **Run the script:**

    ```bash
    ./app.sh
    ```

5. **Follow the on-screen instructions:**

    - The script will display a menu with various options for data analysis.
    - Choose an option by typing the corresponding number and pressing Enter.
    - Follow any additional prompts to select columns or specify conditions for analysis.

6. **View the results:**

    - The script will display the calculated statistics such as mean, median, and standard deviation for the selected column(s).
    - Also your analysis data will be stored in the output.txt file.
## Contributing

Contributions are welcome! If you have suggestions, improvements, or bug fixes, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

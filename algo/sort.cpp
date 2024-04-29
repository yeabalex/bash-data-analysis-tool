#include <iostream>
#include <vector>
#include <fstream>
using namespace std;

class MergeSort {
private:
    vector<float> merge(vector<float>&& left, vector<float>&& right) {
        vector<float> result;
        while (left.size() && right.size()) {
            if (left[0] <= right[0]) {
                result.push_back(left[0]);
                left.erase(left.begin());
            } else {
                result.push_back(right[0]);
                right.erase(right.begin());
            }
        }
        while (left.size()) {
            result.push_back(left[0]);
            left.erase(left.begin());
        }
        while (right.size()) {
            result.push_back(right[0]);
            right.erase(right.begin());
        }
        return result;
    }

public:
    // Recursive function to perform merge sort
    vector<float> mergeSort(vector<float>&& nums) {
        if (nums.size() < 2) {
            return nums; 
        }
        int mid = nums.size() / 2;
        vector<float> left(nums.begin(), nums.begin() + mid);
        vector<float> right(nums.begin() + mid, nums.end());
        return merge(mergeSort(move(left)), mergeSort(move(right)));
    }
};

int main() {
    ofstream write("gdp.txt", ios::app); // Open file for writing
    ifstream read("gdp.txt"); // Open file for reading
    if (!read.is_open()) {
        cout << "Error opening file"; // Check if file opening failed
    } else {
        vector<float> vec;
        MergeSort sorter;
        float nums;
        // Read numbers from file into vector
        while (read >> nums) {
            vec.push_back(nums);
        }
        
        // Sort the numbers using merge sort
        for (float num : sorter.mergeSort(move(vec))) {
            write << endl;
            write << num << endl; // Output sorted numbers to file
        }
        cout << endl; 
    }
    write.close();
    read.close();
    return 0;
}

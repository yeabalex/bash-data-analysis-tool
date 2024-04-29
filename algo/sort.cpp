#include <iostream>
#include <vector>
#include <fstream>
using namespace std;

class MergeSort {
private:
    vector<float> merge(vector<float>&& left, vector<float>&& right){
        vector<float> result;
        while (left.size() && right.size()){
            if (left[0] <= right[0]){
                result.push_back(left[0]);
                left.erase(left.begin());
            } else {
                result.push_back(right[0]);
                right.erase(right.begin());
            }
        }
        while (left.size()){
            result.push_back(left[0]);
            left.erase(left.begin());
        }
        while (right.size()){
            result.push_back(right[0]);
            right.erase(right.begin());
        }
        return result;
}
public:
    vector<float> mergeSort(vector<float>&& nums){
        if (nums.size() < 2){
            return nums;
        }
        int mid = nums.size() / 2;
        vector<float> left(nums.begin(), nums.begin() + mid);
        vector<float> right(nums.begin() + mid, nums.end());
        return merge(mergeSort(move(left)), mergeSort(move(right)));
}
};




int main(){
    ofstream write("gdp.txt", ios::app);
    ifstream read("gdp.txt");
    if(!read.is_open()){
        cout<<"Error opening file";
    }else{
    vector<float> vec;
    MergeSort sorter;
    float nums;
    while (read>>nums)
    {
        vec.push_back(nums);
    }
    
    for(float num: sorter.mergeSort(move(vec))){
        cout<<num<<endl;
        write<<endl;
        write<<num<<endl;
    }
    cout<<endl;
}
}

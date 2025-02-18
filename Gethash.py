import hashlib
import wmi
import csv
import os

#create func for get hash key
def get_file_hash (file_path, hash_type='sha256'):
    hash_func = hashlib.new(hash_type)
    with open(file_path, 'rb') as f:
        while chunk := f.read(8192):
            hash_func.update(chunk)
    return hash_func.hexdigest()

#create func for get hardware via wmi module
def get_hardware_hash():
    c = wmi.WMI()
    hardware_info = {}
    for item in c.Win32_ComputerSystemProduct():
        hardware_info['UUID'] = item.UUID
        hardware_info['Name'] = item.Name
    return hardware_info

# Create func for export file.csv and save as location 
def export_hashes_to_csv(hashes, filename= r'C:\Users\Public\Downloads\hashes.csv'):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(hashes.keys())
        writer.writerow(hashes.values())
        
# Running for Func       
if __name__ == "__main__":
    # Create a sample file to hash
    sample_file_path = r'C:\Users\Public\Downloads\example.txt'
    with open(sample_file_path, 'w') as f:
        f.write("This is a sample file for hashing.")  
    # Now we can hash the sample file
    if not os.path.exists(sample_file_path):
        print(f"Error: The file at {sample_file_path} was not found.")
    else:
        try:
            file_hash = get_file_hash(sample_file_path)
            print(f"Hash of the file: {file_hash}")

            # Get hardware hash and export to CSV
            hardware_hash = get_hardware_hash()
            all_hashes = {
                'File Hash': file_hash,
                'UUID': hardware_hash['UUID'],
                'Name': hardware_hash['Name']
            }
            export_hashes_to_csv(all_hashes)
            print(f"Hashes exported to {r'C:\Users\Public\Downloads\hashes.csv'}")
        except Exception as e:
            print(f"An error occurred: {e}")
    

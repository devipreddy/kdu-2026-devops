import os
import random
import string

base_dir = "files"

# Create directory
os.makedirs(base_dir, exist_ok=True)

for i in range(1, 11):
    file_path = os.path.join(base_dir, f"file_{i}.txt")
    
    with open(file_path, "w") as f:
        random_text = ''.join(random.choices(string.ascii_letters + string.digits, k=200))
        f.write(f"Dummy file {i}\n")
        f.write(random_text)

print(" 10 dummy files created inside 'q5_local_files'")
import os

base_dir = "q7_permission_test"

subdirs = ["dir1", "dir2", "dir3"]
files = ["file1.txt", "file2.log", "data.csv"]
shell_files = ["script1.sh", "script2.sh"]

os.makedirs(base_dir, exist_ok=True)

# Create subdirectories
for d in subdirs:
    os.makedirs(os.path.join(base_dir, d), exist_ok=True)

# Create regular files
for f in files:
    with open(os.path.join(base_dir, f), "w") as file:
        file.write("This is a regular file.\n")

# Create shell script files
for sh in shell_files:
    with open(os.path.join(base_dir, sh), "w") as file:
        file.write("#!/bin/bash\necho Hello World\n")

print(" Permission test structure created in 'q7_permission_test'")
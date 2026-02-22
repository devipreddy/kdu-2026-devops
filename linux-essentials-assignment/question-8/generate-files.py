import os

base_dir = "search_test"
os.makedirs(base_dir, exist_ok=True)

for i in range(1, 11):
    file_path = os.path.join(base_dir, f"text_{i}.txt")
    
    with open(file_path, "w") as f:
        f.write("HELLO world\n")
        f.write("This is a test file.\n")
        f.write("HELLO again!\n")

print(" 10 files created with pattern 'HELLO' in 'q8_search_test'")
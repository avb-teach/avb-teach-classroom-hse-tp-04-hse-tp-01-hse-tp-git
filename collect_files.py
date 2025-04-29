import os
import sys
import shutil

input_directory = sys.argv[1]
output_directory = sys.argv[2]

for current_path, folder_names, file_names in os.walk(input_directory):
    for file_name in file_names:
        source_path = os.path.join(current_path, file_name)
        destination_path = os.path.join(output_directory, file_name)

        if not os.path.exists(destination_path):
            shutil.copy(source_path, destination_path)
        else:
            copy_index = 1
            while True:
                base_name, extension = os.path.splitext(file_name)
                new_file_name = base_name + str(copy_index) + extension
                destination_path = os.path.join(output_directory, new_file_name)
                if not os.path.exists(destination_path):
                    shutil.copy(source_path, destination_path)
                    break
                copy_index += 1

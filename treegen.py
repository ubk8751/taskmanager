import os

def generate_folder_structure(path, exclusions, output_file):
    with open(output_file, 'w') as f:
        for root, dirs, files in os.walk(path):
            for exclusion in exclusions:
                if exclusion in dirs:
                    dirs.remove(exclusion)
            level = root.replace(path, '').count(os.sep)
            indent = ' ' * 4 * (level)
            f.write('{}{}/\n'.format(indent, os.path.basename(root)))
            subindent = ' ' * 4 * (level + 1)
            for file in files:
                f.write('{}{}\n'.format(subindent, file))

if __name__ == "__main__":
    base_path = r'/home/ubk8751/documents/taskmanager'
    exclusions = ['venv', '.git', '__pycache__']
    output_file = 'folder_structure.txt'
    generate_folder_structure(base_path, exclusions, output_file)
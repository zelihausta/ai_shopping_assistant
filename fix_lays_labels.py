import os

LAY_PATH = r"C:\Users\Zeliha_066\Downloads\lays"
  # ← GEREKİRSE YOLU DÜZENLE

def fix_labels(split):
    labels_dir = os.path.join(LAY_PATH, split, "labels")
    for file in os.listdir(labels_dir):
        if not file.endswith(".txt"):
            continue

        file_path = os.path.join(labels_dir, file)
        with open(file_path, "r") as f:
            lines = f.readlines()

        new_lines = []
        for line in lines:
            parts = line.strip().split()
            if not parts:
                continue
            parts[0] = "3"  # Lays class id
            new_lines.append(" ".join(parts) + "\n")

        with open(file_path, "w") as f:
            f.writelines(new_lines)

    print(f"{split} labels fixed.")

if __name__ == "__main__":
    for split in ["train", "valid", "test"]:
        fix_labels(split)

    print("✅ All Lays labels converted from 0 → 3")

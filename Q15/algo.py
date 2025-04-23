import pandas as pd
import os
import tempfile
from rapidfuzz import fuzz

# Parameters
CHUNK_SIZE = 10000  # adjust for memory
SIMILARITY_THRESHOLD = 35  # [0-100]


# Step 1: External sort on both tables
def external_sort(file_path, key_col, temp_prefix):
    temp_files = []
    for chunk in pd.read_csv(file_path, chunksize=CHUNK_SIZE):
        chunk.sort_values(by=key_col, inplace=True)
        temp_file = tempfile.NamedTemporaryFile(
            delete=False, prefix=temp_prefix, suffix=".csv"
        )
        chunk.to_csv(temp_file.name, index=False)
        temp_files.append(temp_file.name)
    return temp_files


# Step 2: Merge sorted files using fuzzy join
def fuzzy_merge(sorted_files1, sorted_files2, key1, key2, out_file):
    df1_iter = pd.concat([pd.read_csv(f) for f in sorted_files1]).itertuples()
    df2_iter = pd.concat([pd.read_csv(f) for f in sorted_files2]).itertuples()

    matches = []
    for row1 in df1_iter:
        for row2 in df2_iter:
            similarity = fuzz.token_sort_ratio(getattr(row1, key1), getattr(row2, key2))
            print(similarity, getattr(row1, key1), getattr(row2, key2))
            if similarity >= SIMILARITY_THRESHOLD:
                matches.append((row1, row2))
        df2_iter = pd.concat(
            [pd.read_csv(f) for f in sorted_files2]
        ).itertuples()  # reset iterator

    # Write results
    with open(out_file, "w") as f:
        f.write("Table1_ID,Table1_Name,Table2_ID,Table2_Name,Similarity\n")
        for r1, r2 in matches:
            f.write(
                f"{r1[0]},{getattr(r1, key1)},{r2[0]},{getattr(r2, key2)},{fuzz.token_sort_ratio(getattr(r1, key1), getattr(r2, key2))}\n"
            )


# Example usage
table1 = "universities.csv"  # contains: id,name
table2 = "students.csv"  # contains: id,university_name

sorted1 = external_sort(table1, "name", "uni_sort_")
sorted2 = external_sort(table2, "university_name", "student_sort_")

fuzzy_merge(sorted1, sorted2, "name", "university_name", "joined_output.csv")

# Cleanup temp files
for f in sorted1 + sorted2:
    os.remove(f)

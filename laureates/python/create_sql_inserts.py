import json
import re

home   = 'C:\Projects\json-in-sql-db'
srcFn  = 'laureates\laureates.json'
distFn = 'laureates\insert_laureates.sql'


def is_valid_json(s):
    try:
        json.loads(s)
        return True
    except json.decoder.JSONDecodeError:
        return False


def replace_umlauts(l):
    l = l.replace("&auml;", "ä")
    l = l.replace("&Auml;", "Ä")
    l = l.replace("&ouml;", "ö")
    l = l.replace("&Ouml;", "Ö")
    l = l.replace("&uuml;", "ü")
    l = l.replace("&Uuml;", "Ü")
    l = l.replace("&szlig;", "ß")
    return l


def clean(laureates):
    cleaned_laureates = []
    for laureate in laureates['laureates']:
        laureate_as_str = str(laureate)

        laureate_as_str = re.sub(r'(\w\s*)\'(\s*\w)', r'\1\|\2', laureate_as_str)
        laureate_as_str = laureate_as_str.replace("'", "\"").replace("\"\"", "\"").replace('\n', '').replace("\|", "'")

        laureate_as_str = laureate_as_str.replace('\\xad', '')
        laureate_as_str = replace_umlauts( laureate_as_str)

        cleaned_laureates.append(laureate_as_str)
    return cleaned_laureates


def check_validity(cleanedLaureates):
    valid_laureates = []
    invalid_laureates = []
    for laureate in cleanedLaureates:
        if is_valid_json(laureate):
            valid_laureates.append(laureate)
        else:
            invalid_laureates.append(laureate)
    return (valid_laureates, invalid_laureates)


def create_sql_inserts(laureates, fn):
    with open(fn, 'w', encoding='utf-8') as f:
        f.write("SET DEFINE OFF\n")
        for l in laureates:
            f.write("INSERT INTO laureates(laureate) VALUES( q'!")
            f.write(l)
            f.write("!');\n")
        f.write("COMMIT;\n")


with open(home + '\\' + srcFn, 'r', encoding='utf-8') as f:
    laureates = json.load(f)

cleaned_laureates = clean(laureates)
(valid_laureates, invalid_laureates) = check_validity(cleaned_laureates)
create_sql_inserts(valid_laureates, home + '\\' + distFn)

print('#valid laureates: ', len(valid_laureates))
print('#invalid laureates: ', len(invalid_laureates))
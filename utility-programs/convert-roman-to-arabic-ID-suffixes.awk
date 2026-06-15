#!/usr/bin/awk -f

function roman_to_arabic(r,    i, cur, prev, total, c) {
    total = 0
    prev = 0
    for (i = length(r); i >= 1; i--) {
        c = substr(r, i, 1)
        if      (c == "i") cur = 1
        else if (c == "v") cur = 5
        else if (c == "x") cur = 10
        else if (c == "l") cur = 50
        else if (c == "c") cur = 100
        else if (c == "d") cur = 500
        else if (c == "m") cur = 1000
        else cur = 0
        if (cur < prev) total -= cur
        else            total += cur
        prev = cur
    }
    return total
}

function convert_roman_suffix(line,    result, before, roman, after, arabic) {
    result = ""
    while (1) {
        # Match either xml:id="...digits.roman" or label content ...digits.roman"
        if (match(line, /(xml:id="|[0-9]+\.[0-9]+\.[0-9]+\.)[ivxlcdm]+"/) ||
            match(line, /[0-9]+\.[ivxlcdm]+"/ )) {

            # Isolate just the roman numeral before the closing quote
            before = substr(line, 1, RSTART + RLENGTH - 1)
            after  = substr(line, RSTART + RLENGTH)       # from " onward

            # Strip back to find where the roman numeral starts
            match(before, /[ivxlcdm]+$/)
            roman  = substr(before, RSTART)
            before = substr(before, 1, RSTART - 1)

            arabic = roman_to_arabic(roman)
            result = result before "add" arabic
            line   = "\"" after
        } else {
            break
        }
    }
    return result line
}

{
    line = $0

    # Only process lines containing xml:id= or a label with the SS reference pattern
    if (line ~ /xml:id="[^"]*[0-9]+\.[ivxlcdm]+"/ || \
        line ~ /[0-9]+\.[0-9]+\.[0-9]+\.[ivxlcdm]+"/) {
        line = convert_roman_suffix(line)
    }

    print line
}

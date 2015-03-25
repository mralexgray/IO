
CFLAGS = -fmodules -F$(USER_FWKS) -std=c11 -fobjc-arc -v -framework AtoZIO

test: test/main.m
	$(CC) $^ -o  test/$@  $(CFLAGS)
	
clean:
	rm -f test

.PHONY: clean test



  # "$CDDIR/main.m" "$CDDIR/../src/scrutil.m" -I"$CDDIR/../src" -fmodules; \
	
	# $(CC) $^ -o $@ -Wall -Wextra


# test: test/main.m
# 	$(CC) $^ -o $@ -Wall -Wextra


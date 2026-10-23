# buildPythonApplication enables __structuredAttrs by default since 26.11.
# sphinxHook still expands sphinxBuilders as a space-separated string, so it
# only sees the first builder ("html") and never creates the `man` output.
# Drop this once sphinxHook handles Bash arrays.
final: prev: {
  khal = prev.khal.overrideAttrs (_: {
    __structuredAttrs = false;
  });
}

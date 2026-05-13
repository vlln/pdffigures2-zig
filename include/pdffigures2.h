#ifndef PDFFIGURES2_H
#define PDFFIGURES2_H

#ifdef __cplusplus
extern "C" {
#endif

/* Opaque context holding MuPDF state. Not thread-safe. */
typedef struct Pdffigures2Context Pdffigures2Context;

/**
 * Create a new pdffigures2 context.
 * Returns NULL on failure. Must be freed with pdffigures2_destroy().
 */
Pdffigures2Context* pdffigures2_create(void);

/**
 * Destroy a pdffigures2 context. Safe no-op on NULL.
 */
void pdffigures2_destroy(Pdffigures2Context* ctx);

/**
 * Extract figures from a PDF file.
 * Returns a JSON string (malloc'd) that must be freed with pdffigures2_free_string().
 * Returns NULL on error — call pdffigures2_last_error() for details.
 *
 * JSON format: array of objects with fields:
 *   name, figType, page, caption, captionBoundary, regionBoundary, imageText
 */
char* pdffigures2_extract(Pdffigures2Context* ctx, const char* pdf_path, int dpi);

/**
 * Extract figures with base64-encoded PNG images embedded in the JSON.
 * Returns a JSON string (malloc'd) that must be freed with pdffigures2_free_string().
 * Returns NULL on error.
 *
 * JSON format: same as pdffigures2_extract, plus "imageBase64" field per figure.
 */
char* pdffigures2_extract_with_images(Pdffigures2Context* ctx, const char* pdf_path, int dpi);

/**
 * Free a string returned by pdffigures2_extract() or pdffigures2_extract_with_images().
 * Safe no-op on NULL.
 */
void pdffigures2_free_string(char* str);

/**
 * Get the last error message for this context.
 * Returns NULL if no error has occurred.
 * The returned pointer is valid until the next call on this context.
 */
const char* pdffigures2_last_error(Pdffigures2Context* ctx);

#ifdef __cplusplus
}
#endif

#endif /* PDFFIGURES2_H */
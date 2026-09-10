# Desk Scanner

This is the Android-friendly web/PWA version of Desk Scanner.

IMPORTANT:
Camera access requires a secure web origin. Open this app using an HTTPS URL.
Do not open index.html directly from Google Drive/file storage.

## GitHub Pages deployment

1. Create a GitHub repository, for example `desk-scanner`.
2. Upload these three files to the repository root:
   - index.html
   - manifest.webmanifest
   - sw.js
3. In GitHub: Settings -> Pages.
4. Set the source to deploy from the `main` branch and `/ (root)`.
5. Open the HTTPS URL GitHub gives you.
6. In Android Chrome, allow camera access.
7. Chrome can then install it from the browser menu with "Add to Home screen" / "Install app".

GitHub Pages serves static files over HTTPS, which is what the browser camera API needs.

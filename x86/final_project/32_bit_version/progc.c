#include <stdio.h>
#include <stdlib.h>

//extern char *funcName(char *s);
void flipdiagbmp1(char *img, int imageWidth);

// Structure of 62 bit bmp header (64 aligned to 62)
typedef struct {
	unsigned short bfType; 
	unsigned long  bfSize; 
	unsigned short bfReserved1; 
	unsigned short bfReserved2; 
	unsigned long  bfOffBits; 
	unsigned long  biSize; 
	long  biWidth; 
	long  biHeight; 
	short biPlanes; 
	short biBitCount; 
	unsigned long  biCompression; 
	unsigned long  biSizeImage; 
	long biXPelsPerMeter; 
	long biYPelsPerMeter; 
	unsigned long  biClrUsed; 
	unsigned long  biClrImportant;
	unsigned long  RGBQuad_0;
	unsigned long  RGBQuad_1;
} bmpHeader;

///////////////// SAVE BMP FUNCTION    ///////////////////////////
// -1 if file cannot open, -2 if cannot write  header to file, -3 if cannot write bitmap, 0 if success
int saveBMP(const bmpHeader bmpHead, unsigned char* bmpFileData, int sizeOfFileData) {
	FILE * bmpFile;

    // File opening
	if ((bmpFile = fopen("out.bmp", "wb")) == 0) return -1;

    // Writing header to  output file (the same as on input)
	if (fwrite(&bmpHead, sizeof(bmpHeader), 1, bmpFile) != 1) {
		fclose(bmpFile);
		return -2;
	}

    // Writing (processed) bitmap to output file
    if (fwrite(bmpFileData, sizeOfFileData, 1, bmpFile) != 1) {
		fclose(bmpFile);
		return -3;
	}

	fclose(bmpFile);
	return 0;
}
//////////////////////////////////////////////////////////////////


///////////////// READ BMP FUNCTION    ///////////////////////////
// returns pointer to bitmap
unsigned char *processBMP(char* filename) {
    bmpHeader bmpHead;
    FILE *imgFile = fopen(filename, "rb");   //read the file
    if (!imgFile)
        return NULL;
    // Header Read
    fread((void *) &bmpHead, sizeof(bmpHead), 1, imgFile);

    int imageWidth = bmpHead.biWidth;
    int imageHeight = bmpHead.biHeight;

    printf("Input Image Info:\n");
    printf("ImageWidth:\t\t%d\n", imageWidth);
    printf("ImageHeight:\t\t%d\n", imageHeight);

    int padding = 0;
    while ((imageWidth + padding) % 32 != 0) padding++;
    int actualImageWidth = imageWidth + padding;
    int byteImageWidth = actualImageWidth / 8;

    printf("Padding:\t\t%d\n", padding);
    printf("ActualImageWidth:\t%d\n", actualImageWidth);

    unsigned long imageDataSize = sizeof(unsigned char) * imageHeight * actualImageWidth / 8;
    printf("Total bitmap size:\t%d\n", imageDataSize);

    unsigned char *imageDataArr = (unsigned char*) malloc(imageDataSize);
    
    // Bitmap Read
    fread(imageDataArr, sizeof(unsigned char), imageDataSize, imgFile);

    // ==== Assembly image processing =====
    flipdiagbmp1(imageDataArr, imageWidth);

    
    printf("Saving output file to \"out.bmp\"...\n");
    if (!saveBMP(bmpHead, imageDataArr, imageDataSize))
        printf("File saved!\n");
    else
        printf("There was problem saving the file. Terminating program");

    fclose(imgFile); //close the file

    return imageDataArr;
}

///////////////////////////////////////////////////

int main (int argc, char* argv[]) {
	if (argc != 2) printf("Please enter 1 inline argument\n");
    else {
        printf("Program mirroring image diagonally such that (x, y) pixel becomes (y, x). Processing input image...\n");
        char *res = processBMP(argv[1]);
        if (!res)
            printf("There was a problem processing the file. Terminationg program\n");
        else
            free(res);
    }
    return 0; 
    
}

//#pragma pack(pop)

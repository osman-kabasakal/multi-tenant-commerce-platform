import {Component, EventEmitter, Input, Output} from '@angular/core';

@Component({
  selector: 'app-file-upload-component',
  templateUrl: './file-upload-component.component.html',
  styleUrl: './file-upload-component.component.scss'
})
export class FileUploadComponentComponent {
  @Input() label: string = 'Upload a file';
  @Input() accept: string = '*/*';
  @Input() maxSize: number = 1024 * 1024; // 1MB default
  @Input() multiple: boolean = false;
  @Input() fileHint: string = 'Max size: 1MB';

  @Output() fileSelected = new EventEmitter<File[]>();

  selectedFiles: File[] = [];
  isDragging = false;

  onFileSelected(event: any): void {
    const files = event.target.files as FileList;
    this.processFiles(files);
  }

  onDragOver(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.isDragging = true;
  }

  onDragLeave(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.isDragging = false;
  }

  onDrop(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.isDragging = false;

    if (event.dataTransfer?.files) {
      this.processFiles(event.dataTransfer.files);
    }
  }

  processFiles(files: FileList): void {
    const validFiles: File[] = [];

    for (let i = 0; i < files.length; i++) {
      const file = files[i];

      if (file.size <= this.maxSize) {
        validFiles.push(file);
      } else {
        console.error(`File ${file.name} exceeds maximum size of ${this.maxSize / 1024 / 1024}MB`);
      }
    }

    this.selectedFiles = validFiles;
    this.fileSelected.emit(validFiles);
  }

  removeFile(index: number): void {
    this.selectedFiles.splice(index, 1);
    this.fileSelected.emit(this.selectedFiles);
  }
}

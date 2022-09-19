/*
 * Variables
 */

let filesList = [];
const classDragOver = "drag-over";
const fileInputMulti = document.querySelector("#multi-selector-uniq #files");
// DEMO Preview
const multiSelectorUniqPreview = document.querySelector("#multi-selector-uniq #preview");

/*
 * Functions
 */

/**
 * Returns the index of an Array of Files from its name. If there are multiple files with the same name, the last one will be returned.
 * @param {string} name - Name file.
 * @param {Array<File>} list - List of files.
 * @return number
 */
function getIndexOfFileList(name, list) {
    return list.reduce(
        (position, file, index) => (file.name === name ? index : position),
        -1
    );
}

/**
 * Returns a File in text.
 * @param {File} file
 * @return {Promise<string>}
 */
async function encodeFileToText(file) {
    return file.text().then((text) => {
        return text;
    });
}

/**
 * Returns an Array from the union of 2 Arrays of Files avoiding repetitions.
 * @param {Array<File>} newFiles
 * @param {Array<File>} currentListFiles
 * @return Promise<File[]>
 */
async function getUniqFiles(newFiles, currentListFiles) {
    return new Promise((resolve) => {
        Promise.all(newFiles.map((inputFile) => encodeFileToText(inputFile))).then(
            (inputFilesText) => {
                // Check all the files to save
                Promise.all(
                    currentListFiles.map((savedFile) => encodeFileToText(savedFile))
                ).then((savedFilesText) => {
                    let newFileList = currentListFiles;
                    inputFilesText.forEach((inputFileText, index) => {
                        if (!savedFilesText.includes(inputFileText)) {
                            newFileList = newFileList.concat(newFiles[index]);
                        }
                    });
                    resolve(newFileList);
                });
            }
        );
    });
}

async function getOnlyImages(newFiles) {
    var message = ''
    for (var i = 0; i < newFiles.length; i++) {
        var filePath = newFiles[i]
        // console.log(filePath.name)
        // console.log(filePath.size)
        // if(filePath.name.includes('jpg')||filePath.name.includes('png')||filePath.name.includes('gif')||filePath.name.includes('jpeg')){

        // }else{
        //     newFiles.splice(i, 1)
        //     i-=1
        // }
        if (filePath.size > 2000000) {
            newFiles.splice(i, 1)
            i -= 1
            message = 'No puedes subir archivos con peso mayor a 2MB'
        }
    }
    return newFiles, message;
}

/**
 * Only DEMO. Render preview.
 * @param currentFileList
 * @Only .EMO> param target.
 * @
 */
function renderPreviews(currentFileList, target, inputFile) {
    //
    target.textContent = "";
    currentFileList.forEach((file, index) => {
        //const table = document.createElement("table")
        //const row = document.createElement("tr")
        //const td1 = document.createElement("td")
        //const td2 = document.createElement("td")
        //table.style.width="100%"
        //row.style.width="100%"
        //td1.style.width="80%"
        //td2.style.width ="20%"
        const myLi = document.createElement("li");
        myLi.textContent = recortarNombre(file.name);
        myLi.className = "list-group-item";
        myLi.setAttribute("draggable", 'true');
        myLi.dataset.key = file.name;
        myLi.addEventListener("drop", eventDrop);
        myLi.addEventListener("dragover", eventDragOver);
        const myButtonRemove = document.createElement("button");
        myButtonRemove.innerHTML = "<i class='fas fa-trash'></i>";
        myButtonRemove.style.float="right"
        myButtonRemove.className = "btn btn-danger";
        myButtonRemove.addEventListener("click", () => {
            filesList = deleteArrayElementByIndex(currentFileList, index);
            inputFile.files = arrayFilesToFileList(filesList);
            return renderPreviews(filesList, multiSelectorUniqPreview, inputFile);
        });
        myLi.appendChild(myButtonRemove);
        //td1.textContent = "asdasd"
        //td2.appendChild(myButtonRemove)
        //row.appendChild(td1)
        //row.appendChild(td2)
        //table.appendChild(row)
        //myLi.appendChild(table)
        target.appendChild(myLi);
    });
}
function recortarNombre(filename) {
    //console.log(filename.length)
    if (filename.length > 25) {
        filename = filename.substr(0, 24) + '...'
        //console.log(filename)
    }
    return filename
}
/**
 * Returns a copy of the array by removing one position by index.
 * @param {Array<any>} list
 * @param {number} index
 * @return {Array<any>} list
 */
function deleteArrayElementByIndex(list, index) {
    return list.filter((item, itemIndex) => itemIndex !== index);
}

/**
 * Returns a FileLists from an array containing Files.
 * @param {Array<File>} filesList
 * @return {FileList}
 */
function arrayFilesToFileList(filesList) {
    return filesList.reduce(function (dataTransfer, file) {
        dataTransfer.items.add(file);
        return dataTransfer;
    }, new DataTransfer()).files;
}


/**
 * Returns a copy of the Array by swapping 2 indices.
 * @param {number} firstIndex
 * @param {number} secondIndex
 * @param {Array<any>} list
 */
function arraySwapIndex(firstIndex, secondIndex, list) {
    const tempList = list.slice();
    const tmpFirstPos = tempList[firstIndex];
    tempList[firstIndex] = tempList[secondIndex];
    tempList[secondIndex] = tmpFirstPos;
    return tempList;
}

/*
 * Events
 */

// Input file
fileInputMulti.addEventListener("input", async () => {
    // Get files list from <input>
    var newFilesList = Array.from(fileInputMulti.files);
    if (newFilesList.length > 10) {
        //console.log(newFilesList.length)
        newFilesList = newFilesList.slice(0, 10)
        Swal.fire(
            'Lo sentimos',
            'No puedes subir mas de 10 archivos a la vez.',
            'error'
        )
    }
    //Obtener solo tipos permitidos
    newFilesList, msgAlert = await getOnlyImages(newFilesList);
    if (msgAlert != '') {
        Swal.fire(
            'Lo sentimos',
            msgAlert,
            'error'
        )
    }
    // Update list files
    filesList = await getUniqFiles(newFilesList, filesList);
    filesList = filesList.splice(0, 10)
    // Only DEMO. Redraw
    renderPreviews(filesList, multiSelectorUniqPreview, fileInputMulti);
    // Set data to input
    fileInputMulti.files = arrayFilesToFileList(filesList);
});

// Drag and drop

// Drag Start - Moving element.
let myDragElement = undefined;
document.addEventListener("dragstart", (event) => {
    // Saves which element is moving.
    myDragElement = event.target;
});

// Drag over - Element that is below the element that is moving.
function eventDragOver(event) {
    // Remove from all elements the class that will show that it is a drop zone.
    event.preventDefault();
    multiSelectorUniqPreview
        .querySelectorAll("li")
        .forEach((item) => item.classList.remove(classDragOver));

    // On the element above it, the class is added to show that it is a drop zone.
    event.target.classList.add(classDragOver);
}

// Drop - Element on which it is dropped.
function eventDrop(event) {
    // The element that is underneath the element that is moving when it is released is captured.
    const myDropElement = event.target;
    // The positions of the elements in the array are swapped. The dataset key is used as an index.
    filesList = arraySwapIndex(
        getIndexOfFileList(myDragElement.dataset.key, filesList),
        getIndexOfFileList(myDropElement.dataset.key, filesList),
        filesList
    );
    // The content of the input file is updated.
    fileInputMulti.files = arrayFilesToFileList(filesList);
    // Only DEMO. Changes are redrawn.
    renderPreviews(filesList, multiSelectorUniqPreview, fileInputMulti);
}

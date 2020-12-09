document.addEventListener("turbolinks:load", ()=>{
  document.querySelector("#file")?.addEventListener("change", ()=> {
    p = document.getElementById("pdf_only_error");
    file_name = document.querySelector("#file").files[0].type;
    if(file_name != "application/pdf") {
      p.innerText = "The format is not PDF. The file will not be sent";
      p.style.color = "red";
    }
    else {
      p.innerText = "";
    }
  })
  event = new Event("change");
  document.querySelector("#file")?.dispatchEvent(event);
})

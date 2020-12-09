document.addEventListener("turbolinks:load", ()=>{
  document.querySelectorAll(".selection_menu a")?.forEach( (item)=>{
    item.addEventListener("mouseover", ()=> {
      item.style.color = "red";
    });
  })
  document.querySelectorAll(".selection_menu a")?.forEach( (item)=>{
    item.addEventListener("mouseout", ()=> {
      item.style.color = "black";
    });
  })
})

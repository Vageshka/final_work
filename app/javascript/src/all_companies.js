function more_details(data, item){
  item.children[0].disabled = true;
  td = document.getElementById(data["id"]);
  td.hidden = false;
  ul = td.children[0];
  ul.children[0].firstElementChild.innerText = data["vacancy"];
  ul.children[1].firstElementChild.innerText = data["requirements"];
  ul.children[2].firstElementChild.innerText = data["conditions"];
}

document.addEventListener("turbolinks:load", ()=>{
  document.querySelectorAll(".button_to")?.forEach( (item)=>{
    item.addEventListener('ajax:success', (event)=>{
      [data,status,xhr] = event.detail;
      if(data["id"]){
        more_details(data, item);
      }
      else{
        if(data["success"]){
          if(data["action"]){
            tr = item.parentElement.parentElement;
            tr.parentElement.removeChild(tr.nextElementSibling);
            tr.parentElement.removeChild(tr);
          }
          else{
            item.children[0].disabled = true;
            item.parentElement.previousElementSibling.innerText = "yes";
          }
        }
        else {
          alert(data["errors"].join('\n'));
        }
      }
    })
  })
  document.querySelectorAll(".roll_up")?.forEach( (item)=>{
    item.addEventListener('click', () =>{
      td = item.parentElement
      td.hidden = true
      document.getElementById("btn"+td.id).disabled = false
    })
  })
})

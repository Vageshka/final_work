function more_details(data, item){
  item.children[0].disabled = true;
  td = document.getElementById(data["id"]);
  td.hidden = false;
  ul = td.children[0];
  if(data["vacancy"]){
    ul.children[0].firstElementChild.innerText = data["vacancy"];
    ul.children[1].firstElementChild.innerText = data["requirements"];
    ul.children[2].firstElementChild.innerText = data["conditions"];
  }
  if(data["departament"]){
    ul.children[0].firstElementChild.innerText = data["departament"];
    ul.children[1].firstElementChild.innerText = data["group"];
  }
}

document.addEventListener("turbolinks:load", ()=>{

  document.querySelectorAll(".more")?.forEach( (item)=>{
    item = item.parentElement;
    item.addEventListener('ajax:success', (event)=>{
      [data,status,xhr] = event.detail;
      more_details(data, item);
    })
  });

  document.querySelectorAll(".offer")?.forEach( (item)=>{
    item = item.parentElement;
    item.addEventListener('ajax:success', (event)=>{
      [data,status,xhr] = event.detail;
      if(data["success"]){
        item.children[0].disabled = true;
        item.parentElement.previousElementSibling.innerText = "yes";
      }
      else{
        alert(data["errors"].join('\n'));
      }
    })
  });

  document.querySelectorAll(".del_row_if_suc")?.forEach( (item)=>{
    item = item.parentElement;
    item.addEventListener('ajax:success', (event)=>{
      [data,status,xhr] = event.detail;
      if(data["success"]){
        tr = item.parentElement.parentElement;
        tr.parentElement.removeChild(tr.nextElementSibling);
        tr.parentElement.removeChild(tr);
      }
      else{
        alert(data["errors"].join('\n'));
      }
    })
  });

  document.querySelectorAll(".roll_up")?.forEach( (item)=>{
    item.addEventListener('click', () =>{
      td = item.parentElement
      td.hidden = true
      document.getElementById("btn"+td.id).disabled = false
    })
  })
})

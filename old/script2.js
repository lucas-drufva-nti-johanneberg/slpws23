
var movingItem = null;
let originalItem = null;

addEventListener('mousedown', (event) => {
  const mx = event.clientX;
  const my = event.clientY;

  console.log("MX: " + mx + " MY: " + my)

  const passengers = Array.from(document.getElementsByClassName("passenger"))
  
  //console.log(passengers[0].getBoundingClientRect())

  for (const passengerItem of passengers) {
    const bound = passengerItem.getBoundingClientRect()
    //console.log(bound);
    if(my > bound.top && my < bound.bottom && mx < bound.right && mx > bound.left)
    {
      console.log("Clicked!")
      movingItem = passengerItem.cloneNode(true);
      document.body.appendChild(movingItem);
      passengerItem.style.visibility = 'hidden';
      originalItem = passengerItem;
      movingItem.style.position = 'fixed';
      movingItem.style.top = 0;
      movingItem.style.left = 0;
      movingItem.style.transform = "translate(" + mx + "px, " + my + "px)";
    }
  }

});

addEventListener('mouseup', (event) => {
  const mx = event.clientX;
  const my = event.clientY;

  const passengers = Array.from(document.getElementsByClassName("passenger"))

  for(let i = 0; i < passengers.length; i++)
  {
    if(passengers[i] == movingItem) continue;

    const bound = passengers[i].getBoundingClientRect();

    if (my > bound.top - 80 && my < bound.bottom)
    {
      passengers[i].parentNode.insertBefore(originalItem, passengers[i])
      originalItem.style.visibility = 'visible';
    }
  }

  movingItem.remove();
  movingItem = null;
 
  //cleanup
  for (const passengerItem of passengers) {
    passengerItem.style.transform = "";
    passengerItem.style.visibility = 'visible';
  }
})

addEventListener('mousemove', (event) => {
  if(movingItem == null) return;
  event.preventDefault();
  
  const mx = event.clientX;
  const my = event.clientY;

  movingItem.style.transform = "translate(" + mx + "px, " + my + "px)";

  const passengers = Array.from(document.getElementsByClassName("passenger"))

  for (const passengerItem of passengers) {
    const bound = passengerItem.getBoundingClientRect()
    // console.log(bound);
    if(my > bound.top && my < bound.bottom - 40 && passengerItem != movingItem)
    {
      console.log("moved");
      console.log("mx: " + mx + " my: " + my + " bound.top: " + bound.top + " bound.bottom: " + bound.bottom)
      //passengerItem.style.marginTop = "5em";
      passengerItem.style.transform = "translate(0, -40px)";
    }
    else if(my < bound.bottom - 80){
      passengerItem.style.transform = "translate(0, 0)";
    }
  }
})

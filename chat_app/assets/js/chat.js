const sendMessage = {
  mounted() {
    const input = document.getElementById('input-message');

    let enter = false;
    let ctrl = false;

    input.addEventListener('keydown', (e) => {
      if (e.key == 'Enter')
      {
        enter = true;
        e.preventDefault();
      }

      if (e.ctrlKey)
      {
        ctrl = true;
      }

      if(enter && ctrl)
      {
        this.pushEvent('send_message', {message: {message: e.target.value}});
        e.target.value = '';
      }
      return false;
    });

    input.addEventListener('keyup', (e) => {
      if (e.key == 'Enter')
      {
        enter = false;
        e.preventDefault()
      }

      if (e.ctrlKey)
      {
        ctrl = false;
      }

      return false;
    });

    // input.addEventListener('keypress', (e) => {
    //   console.log('Enter : ', e.key == 'Enter', ' | Ctrl : ', e.ctrlKey);
    //   if (e.key == 'Enter')
    //   {
    //     if (e.ctrlKey)
    //     {
    //       this.pushEvent('send_message', {message: {message: e.target.value}});
    //       e.target.value = '';
    //     };
    //     e.preventDefault();
    //     return false;
    //   }
    // });
  }
};

const scrollMessage = {
  mounted(){
    scroll();
  },
  updated(){
    scroll();
  }
}

const scroll = () => {
  const scrollBox = document.getElementById('scroll-box');
  scrollBox.scrollTop = scrollBox.scrollHeight;
}

export {sendMessage, scrollMessage};
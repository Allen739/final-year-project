//signup

function showSection(id, event) {
    if (event) event.preventDefault();

  document.querySelectorAll("main section").forEach(sec=>{sec.classList.remove("active")

      });
    const section=document.getElementById(id);
    if (section) {
        section.classList.add("active");
    }else{
        console.error("No section found with id", id);
    }
   }

   function logoutUser(event) {
    if (event) event.preventDefault();
    window.location.href="login.html"
   }

const signupForm = document.getElementById(signupForm);
if(signupForm) {
    signupForm.addEventListener ("submit", function(e) {
        e.preventDefault(); //prevent page reload
    
    const name=document.getElementById ("signupName").value;
    const email=document.getElementById ("signupEmail").value;
    const password=document.getElementById ("signupPassword").value;
    const role=document.getElementById ("signupRole").value;
    const message=document.getElementById ("signupMessage");

    //check if the user already exist
    let users= JSON.parse (localStorage.getItem("users")) || [];
    let userEixsts = users.find (u=> u.email === email);

    if (userExists) {
        message.textContent = "User already Exists!";
        return;
    }

    //save user to local storage (simulated Database)
    users.push({name, email, password, role});
    localStorage.seItem ("users", JSON, stringify (users));

    message.style.color = "green";
    message.textContent = "Account created successfully! Redirecting to Login...";

    setTimeout(() => {
        window.location.href = "index.html";
    }, 2000);
});
}

//login
const loginForm = document.getElementById ("loginForm");
if (loginForm) {
    loginForm.addEventListener ("submit", function(e) {
        e.preventDefault();

    const email=document.getElementById ("loginEmail").value;
    const password=document.getElementById ("loginPassword").value;
    const message=document.getElementById ("loginMessage");

let users = users.find(u =>u.email === email&& u.password === password);

if (user) {
    //save current user in local storage
    localStorage.setItem ("currentUser", JSON.stringify(user));
    message.style.color = "green";
    message.textContent = "Login successful! REdirecting to dashboard...";

    setTimeout(() => {
        window.location.href = "dashboard.html";
}, 1500);
} else{
    message.style.color ="red";
    message.textContent = "Invalid email or password";
}
});
}



//dark mode
//toggle darkmode if stored in localstorage
if (localStorage.getItem ("darkMode") == "enabled") {
 document.body.classList.add ("dark-mode");
}

//function to toggle darkmode
function toggleDarkMode () {
    document.body.classList.toggle ("dark-mode");
    if (document.body.classList.contains ("dark-mode")) {
        localStorage.setItem("darkMode", "enables");
    }else {
        localStorage.setItem("darkMode", "disabled");
    }
}


const Microphone = document.getElementById('hablando');
const PlayerId = document.getElementById('id');
const AllHud = document.getElementById('todo');
const Job = document.getElementById('job');

const BlackMoney = document.getElementById('blackmoney');
const Money = document.getElementById('dinero');
const Bank = document.getElementById('bank');

const Health = document.getElementById('vidaBar');
const Food = document.getElementById('comida');
const Drink = document.getElementById('bebida');
const Armor = document.getElementById('armadura');
const Stamina = document.getElementById('estamina');

const vsStamina = document.getElementById('VisibleStamina');
const vsArmor = document.getElementById('VisibleArmor')

function formatNumber(num) {
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.');
}

window.addEventListener('message', (e) => {

    let data = e.data

    switch (data.action) {

        case 'show':
            AllHud.style.display = 'block';
        break;

        case 'job': 
            Job.innerText = `${data.job_label.toUpperCase()} - ${data.job_grade_label.toUpperCase()}`
        break;

        case 'toggle':
            (data.toggle) ? document.body.style.display = 'none' : document.body.style.display = 'block';
        break;

        case 'map':
            anime({
                targets: '.container-status',
                translateX: data.mapa ? (data.anchor.x + data.anchor.width * screen.width + 20) : 0,
                translateY: 0,
                rotate: data.mapa ? 360 : 0,
                delay: 0,
                duration: 1500,
                easing: 'easeOutElastic(.6, 1)',
            });
        break;

        case 'act': 
            PlayerId.innerHTML = `ID: ${data.id}`;
            Money.innerHTML = formatNumber(data.accounts['money'].money);
            Bank.innerHTML = formatNumber(data.accounts['bank'].money);
            BlackMoney.innerHTML = formatNumber(data.accounts['black_money'].money);
            Microphone.innerHTML = (data.hablando) ? '<i class="fa-solid fa-microphone"></i>' : '<i class="fa-solid fa-microphone-slash"></i>';
               
            Health.style.height = Math.round(data.health) + '%'
            Food.style.height = Math.round(data.hunger) + '%'
            Drink.style.height = Math.round(data.thirst) + '%'

            if (data.health <= 0)  {
                Health.style.height = '0%';
            } else if (data.food <= 0) {
                Food.style.height = '0%';
            } else if (data.thirst <= 0) {
                Drink.style.height = '0%';
            }

            if (data.stamina >= 0 && data.stamina < 95) {
                vsStamina.style.display = ''
                Stamina.style.height = Math.round(data.stamina) + '%';
            } else {
                vsStamina.style.display = 'none'
            }     
            
            if (data.armour > 0 && data.armour <= 100 && data.health > 0) {
                vsArmor.style.display = ''
                Armor.style.height = Math.round(data.armour) + '%';
            } else {
                vsArmor.style.display = 'none'
            }

        break;

        case 'updatecolors':
            Health.style.background = data.colorvida;
            Food.style.background = data.colorcomida;
            Drink.style.background = data.colorbebida;
            Armor.style.background = data.colorarmadura;
            Stamina.style.background = data.colorestamina;  
        break;

    }
})

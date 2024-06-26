let app = new Vue({
    mode: 'production',
    el: '#app',
    data: {
        user:null,
        cookieValue:"",
        services :[],
    },
    methods:{
        getCookie(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
        },
        getUser(){
            let th = this
            let user = JSON.parse(document.getElementById("user").value)
            th.user = user
            user.value =""
        },
        async splitServicesIntoGroups(services) {
            const groups = [];
            for (let i = 0; i < services.length; i += 3) {
                groups.push(services.slice(i, i + 3));
            }
            return groups;
        },
        async getServices(){
            let response = await fetch('/api/v1/services', {
                method: 'GET',
                headers: {
                    'X-XSRF-TOKEN': this.cookieValue
                }
            })
            if (response.ok) {
                let data = JSON.parse(await response.text())
                let separated_services = await this.splitServicesIntoGroups(data)
                console.log(separated_services)
                this.services = separated_services
            }
        },
        async logout() {
            let response = await fetch('/logout', {
                method: 'POST',
                headers: {
                    'X-XSRF-TOKEN': this.cookieValue
                }
            })
            if (response.ok) {
                await location.reload()
            }
        },
    },
    async created(){
        this.cookieValue = this.getCookie('XSRF-TOKEN')
        this.getUser()
        await this.getServices()
    }
})
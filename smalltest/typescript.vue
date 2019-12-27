<template>
    <div class="hello">
        <h1>{{ msg }}--{{ names }}</h1>
        <input type="text" v-model="txt">
        <p>{{ getTxt }}</p>
        <button @click="add">add</button>
        <p>{{ sum }}</p>
    </div>
</template>

<script lang="ts">
    import {Component, Prop, Vue, Watch} from 'vue-property-decorator'
    import { State, Getter } from "vuex-class"
    import HelloWorld from '@/components/HelloWorld.vue'

    //数据进行类型约束
    export interface Post {
        title: string,
            body: string
    }

    export interface Goods<T>{
        id:number;
    title: string;
    size: T;
    }

    @Component({
        components: {HelloWorld}
    })
    export default class Hello extends Vue {
        //props
        @Prop() private post!: Post
        @Prop() private msg!: string
        @Prop([String, Boolean]) private name!: string | boolean

        //data
        private txt: string = '1'
        private sum: string = '0'
        message = 'hello'
        private apple:Goods<string> = {id:1,title: '苹果', size: 'large'}
        private shoes:Goods<number> = {id:1,title: '苹果', size: 43}

        //computed
        get getTxt() {
            return this.txt
        }
        private get reversedMessage(): string[] {
            return this.message.split('').reverse().join('')
        }

        //Vuex数据
        @State ((state: IPootState) => state.booking.currentStep) step!: number
        //methods
        private add() {
            this.sum++
        }

        //生命周期
        created() {
            console.log('created');
        }
        private mounted(): void {
            console.log('mounted');
        }

        //watch
        @Watch('txt')
        changeTxt(newTxt: sting, oldTxt: string) {
            console.log('newTxt');
        }

    }
</script>

import './app.scss'
import React from 'react'
import ReactDOM from 'react-dom'
import Routes from './Routes'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'
import { Helmet } from 'react-helmet'

document.body.ontouchstart = function () {}

ReactDOM.render(
  <>
    <Helmet>
      <meta charSet='utf-8' />
      <title>.1.country | Harmony</title>
      <meta name='description' content='Harmony’s .1.country unifies Internet domains and crypto names as Web3 identities. Short, onchain names like s.1 store your wallet addresses, digitial collectibles, social reputation – on Harmony across multiple blockchains. Proper, browsable domains like s.country displays your career metrics, vanity links, embedded content – for fans to tips with emojis or pay for work. Yet, s.1 is magically the same as s.country – your creator economy with ONE!' />
    </Helmet>
    <Routes />
    <ToastContainer position='top-left' />
  </>,
  document.getElementById('root')
)

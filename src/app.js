App = {
  loading: false,
  contracts: {},

  load: async () => {
    var config = require('./config.js')
    await App.loadEth()
    await App.loadAccount()
    await App.loadContract()
    await App.render()
  },

  // https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8
  loadEth: async () => {
    if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider
        web3 = new Web3(web3.currentProvider)
      } else {
        window.alert("Please connect to Metamask.")
      }
      // Modern dapp browsers...
      if (window.ethereum) {
        window.web3 = new Web3(ethereum)
        try {
          // Request account access if needed
          await ethereum.enable()
          // Acccounts now exposed
          web3.eth.sendTransaction({/* ... */})
        } catch (error) {
          // User denied account access...
        }
      }
      // Legacy dapp browsers...
      else if (window.web3) {
        App.web3Provider = web3.currentProvider
        window.web3 = new Web3(web3.currentProvider)
        // Acccounts always exposed
        web3.eth.sendTransaction({/* ... */})
      }
      // Non-dapp browsers...
      else {
        console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
      }
    },

  loadAccount: async () => {
    // Set the current blockchain account
    // web3.eth.defaultAccount = web3.eth.accounts[0]  // <- depreceated
    // App.account = web3.eth.defaultAccount

    //
    App.account = ethereum.selectedAddress
  },

  loadContract: async () => {
    // Create a JavaScript version of the smart contract
    const tcg = await $.getJSON('tcg.json')
    App.contracts.tcg = TruffleContract(tcg)
    App.contracts.tcg.setProvider(App.web3Provider)

    // Hydrate the smart contract with values from the blockchain
    try {
        App.tcg = await App.contracts.tcg.deployed()
    } catch(error) {
        console.warn("Tcg: Please connect to the correct ETH network. Cannot find deployed smart contract!")
    }
  },

  render: async () => {
    // Prevent double render
    if (App.loading) {
      return
    }

    // Update app loading state
    App.setLoading(true)

    // Render Account
    $('#account').html(App.account)

    // Render Tasks
    await App.renderTasks()

    // Update loading state
    App.setLoading(false)
  },

  renderCards: async() => {
    const cardCount = await App.tcg.balanceOf(App.account)
    const ownerCards = App.tcg.methods.userOwnedCards.call(App.account)

    for(var i=1; i<=ownerCards.length;i++) {
      const tokenURI = App.tcg.tokenURI(ownerCards[i])

    }
  },

  infuraPin: async() => {
    const https = require('https')

    const projectId = config.INFURA_PROJECT_ID
    const projectSecret = config.INFURA_PROJECT_SECRET

    const options = {
      host: 'ipfs.infura.io',
      port: 5001,
      path: '/api/v0/pin/add?arg=QmeGAVddnBSnKc1DLE7DLV9uuTqo5F7QbaveTjr45JUdQn',
      method: 'POST',
      auth: projectId + ':' + projectSecret
    }

    let req = https.request(options, (res) => {
      let body = ''
      res.on('data', function (chunk) {
        body += chunk
      })
      res.on('end', function () {
        console.log(body)
      })
    })
    req.end()
  }

  // need to work on the ipfs api to store metadata of the tokens on ipfs provided by infura.





  renderTasks: async () => {
    // Load the total task count from the blockchain
    const taskCount = await App.todoList.taskCount()
    const $taskTemplate = $('.taskTemplate')

    // Render out each task with a new task template
    for (var i = 1; i <= taskCount; i++) {
      // Fetch the task data from the blockchain
      const task = await App.todoList.tasks(i)
      const taskId = task[0].toNumber()
      const taskContent = task[1]
      const taskCompleted = task[2]

      // Create the html for the task
      const $newTaskTemplate = $taskTemplate.clone()
      $newTaskTemplate.find('.content').html(taskContent)
      $newTaskTemplate.find('input')
                      .prop('name', taskId)
                      .prop('checked', taskCompleted)
                      .on('click', App.toggleCompleted)

      // Put the task in the correct list
      if (taskCompleted) {
        $('#completedTaskList').append($newTaskTemplate)
      } else {
        $('#taskList').append($newTaskTemplate)
      }

      // Show the task
      $newTaskTemplate.show()
    }
  },

}

$(() => {
  $(window).load(() => {
    App.load()
  })
})

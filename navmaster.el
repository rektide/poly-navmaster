<element id="x-nav-master" constructor="XNavMaster">
<script>
var forEach= Array.prototype.forEach

/**
  For an object o, return a function accepting a prop which produces a non-enumerable bound _propBound copy.
  @param o the Object to make a property-binder for
*/
function makePropBinder(o){
	return function(prop){
		Object.defineProperty(o, "_"+prop+"Bound", {
			value: o[prop].bind(o),
			enumerable: false
		})
	}
}

var XNavMasterProto= Object.create(HTMLElement.prototype)
XNavMasterProto.addNode= function(node){
	if(node.nodeName.toLowerCase() != "x-nav-content")	
		return
}
XNavMasterProto.addNodes= function(nodes){
	forEach.call(nodes, this.addNodeBound)
}
function mutationObserver(mutations){
	mutations.forEach(function(mutation){
		forEach.call(mutation.addedNodes, this._addNodesBound)
	})
}
function makeMutationObserver(self){
	return new MutationObserver(mutationObserver.bind(self))
}
XNavMasterProto.readyCallback= function(){
	["addNodes","addedNodes"].forEach(makePropBind(this))
	this.mutationObserver= makeMutationObserver(this)
	this.mutationObserver.observe(document, {childList: true})
	var els= document.getElementsByTagName("x-nav-element")
	this.addNodes(els)
}
var XNavMaster= this.register("x-nav-master",{prototype:XNavMasterProto})
</script>
</element>
